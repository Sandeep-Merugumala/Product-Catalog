const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// 1. Initialize Firebase Admin
// You need to download your service account key from:
// Firebase Console -> Project Settings -> Service accounts -> Generate new private key
// Save it as 'serviceAccountKey.json' in this scripts folder
const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

if (!fs.existsSync(serviceAccountPath)) {
  console.error('❌ Error: serviceAccountKey.json not found in scripts folder.');
  console.log('👉 Please download it from Firebase Console -> Project Settings -> Service accounts');
  process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// 2. Load Products Data
const productsPath = path.join(__dirname, 'products.json');
const products = JSON.parse(fs.readFileSync(productsPath, 'utf8'));

// 3. Seed Function
async function seedProducts() {
  console.log(`🌱 Starting seed of ${products.length} products...`);
  
  const batchSize = 500; // Firestore batch limit
  let batch = db.batch();
  let count = 0;
  let totalAdded = 0;

  for (const product of products) {
    const docRef = db.collection('products').doc(product.id);
    batch.set(docRef, product);
    count++;

    if (count === batchSize) {
      await batch.commit();
      console.log(`✅ Committed batch of ${count} products.`);
      totalAdded += count;
      batch = db.batch();
      count = 0;
    }
  }

  if (count > 0) {
    await batch.commit();
    totalAdded += count;
    console.log(`✅ Committed final batch of ${count} products.`);
  }

  console.log(`🎉 Successfully added ${totalAdded} products to Firestore.`);
}

// 4. Run Seeder
seedProducts().catch(console.error);
