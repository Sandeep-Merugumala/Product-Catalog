import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Address Model
class Address {
  String id;
  String name;
  String street;
  String city;
  String state;
  String zip;
  String mobile;
  String type; // 'HOME' or 'OFFICE'
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.mobile,
    this.type = 'HOME',
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'mobile': mobile,
      'type': type,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(String id, Map<String, dynamic> map) {
    return Address(
      id: id,
      name: map['name'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      mobile: map['mobile'] ?? '',
      type: map['type'] ?? 'HOME',
      isDefault: map['isDefault'] ?? false,
    );
  }
}

// Address Service
class AddressService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(Address address) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (address.isDefault) {
        // If adding a default address, remove default from others
        await removeDefaultStatus(user.uid);
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .add(address.toMap());
    }
  }

  Future<void> updateAddress(Address address) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (address.isDefault) {
        await removeDefaultStatus(user.uid);
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .doc(address.id)
          .update(address.toMap());
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .doc(addressId)
          .delete();
    }
  }

  Future<void> removeDefaultStatus(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .where('isDefault', isEqualTo: true)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isDefault': false});
    }
  }

  Stream<List<Address>> getAddresses() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .orderBy('isDefault', descending: true) // Defaults first
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Address.fromMap(doc.id, doc.data()))
                .toList();
          });
    } else {
      return Stream.value([]);
    }
  }
}

// Addresses Page (List)
class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressService addressService = AddressService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADDRESS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditAddressPage(),
                ),
              );
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: const [
                  Icon(Icons.add, color: Color(0xFFFF3F6C)),
                  SizedBox(width: 8),
                  Text(
                    'ADD NEW ADDRESS',
                    style: TextStyle(
                      color: Color(0xFFFF3F6C),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Address>>(
              stream: addressService.getAddresses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No addresses found."));
                }

                final addresses = snapshot.data!;
                final defaultAddresses = addresses
                    .where((a) => a.isDefault)
                    .toList();
                final otherAddresses = addresses
                    .where((a) => !a.isDefault)
                    .toList();

                return ListView(
                  children: [
                    if (defaultAddresses.isNotEmpty)
                      _buildAddressSection(
                        "DEFAULT ADDRESS",
                        defaultAddresses,
                        context,
                      ),
                    if (otherAddresses.isNotEmpty)
                      _buildAddressSection(
                        "OTHER ADDRESSES",
                        otherAddresses,
                        context,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(
    String title,
    List<Address> addresses,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        ...addresses.map((address) => _buildAddressItem(address, context)),
      ],
    );
  }

  Widget _buildAddressItem(Address address, BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1), // Separator
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                address.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  address.type,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${address.street}\n${address.city} - ${address.zip}\n${address.state}\n\nMobile: ${address.mobile}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300]),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEditAddressPage(address: address),
                      ),
                    );
                  },
                  child: const Text(
                    'EDIT',
                    style: TextStyle(
                      color: Color(0xFFFF3F6C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    AddressService().deleteAddress(address.id);
                  },
                  child: const Text(
                    'REMOVE',
                    style: TextStyle(
                      color: Color(0xFFFF3F6C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Add/Edit Address Page
class AddEditAddressPage extends StatefulWidget {
  final Address? address;

  const AddEditAddressPage({super.key, this.address});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _mobileController;
  String _type = 'HOME'; // Default
  bool _isDefault = false;
  final AddressService _addressService = AddressService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _streetController = TextEditingController(
      text: widget.address?.street ?? '',
    );
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _zipController = TextEditingController(text: widget.address?.zip ?? '');
    _mobileController = TextEditingController(
      text: widget.address?.mobile ?? '',
    );
    _type = widget.address?.type ?? 'HOME';
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.address?.id ?? '', // ID handled by Firestore for new docs
        name: _nameController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        zip: _zipController.text,
        mobile: _mobileController.text,
        type: _type,
        isDefault: _isDefault,
      );

      if (widget.address == null) {
        await _addressService.addAddress(address);
      } else {
        await _addressService.updateAddress(address);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'ADD NEW ADDRESS' : 'EDIT ADDRESS',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_nameController, "Name"),
              const SizedBox(height: 16),
              _buildTextField(
                _mobileController,
                "Mobile No",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _zipController,
                "Pin Code",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _streetController,
                "Address (House No, Building, Street, Area)",
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_cityController, "City / District"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_stateController, "State")),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Type of Address",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypeChip("HOME"),
                  const SizedBox(width: 12),
                  _buildTypeChip("OFFICE"),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (val) {
                      setState(() {
                        _isDefault = val ?? false;
                      });
                    },
                    activeColor: const Color(0xFFFF3F6C),
                  ),
                  const Text("Make this as default address"),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3F6C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "SAVE ADDRESS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildTypeChip(String label) {
    bool isSelected = _type == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _type = label;
          });
        }
      },
      selectedColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFFFF3F6C) : Colors.grey[300]!,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFFF3F6C) : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
