import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPropertyTab extends StatefulWidget {
  const AddPropertyTab({super.key});

  @override
  State<AddPropertyTab> createState() => _AddPropertyTabState();
}

class _AddPropertyTabState extends State<AddPropertyTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _rentController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  
  String _propertyType = 'Apartment';
  final List<String> _propertyTypes = ['Apartment', 'House', 'Villa', 'Studio', 'PG'];
  
  final Map<String, bool> _amenities = {
    'WiFi': false,
    'AC': false,
    'Parking': false,
    'Gym': false,
    'Swimming Pool': false,
    'Geyser': false,
    'Washing Machine': false,
    'Security': false,
    'Power Backup': false,
    'Furnished': false,
    'Semi-Furnished': false,
    'Balcony': false,
  };

  final List<String> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
        actions: [
          TextButton(
            onPressed: _submitProperty,
            child: const Text('Post'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Upload Section
            Card(
              child: InkWell(
                onTap: _pickImages,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: _selectedImages.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Add Property Photos',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Tap to select from gallery',
                              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _selectedImages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _selectedImages.length) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add, color: Colors.grey),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, color: Colors.white),
                            );
                          },
                        ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Property Details
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Property Title',
                hintText: 'e.g., Spacious 2BHK Apartment',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your property...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            
            const SizedBox(height: 16),
            
            // Property Type Dropdown
            DropdownButtonFormField<String>(
              value: _propertyType,
              decoration: const InputDecoration(
                labelText: 'Property Type',
                border: OutlineInputBorder(),
              ),
              items: _propertyTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _propertyType = value!),
            ),
            
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'Enter property address',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: _pickLocation,
                ),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            
            const SizedBox(height: 16),
            
            // Rent and Room Details
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rentController,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Rent (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bedroomsController,
                    decoration: const InputDecoration(
                      labelText: 'Bedrooms',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bathroomsController,
                    decoration: const InputDecoration(
                      labelText: 'Bathrooms',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Amenities Section
            Text(
              'Amenities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _amenities.entries.map((entry) {
                    return FilterChip(
                      label: Text(entry.key),
                      selected: entry.value,
                      onSelected: (selected) {
                        setState(() => _amenities[entry.key] = selected);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            ElevatedButton(
              onPressed: _submitProperty,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Post Property'),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _pickImages() {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker integration pending')),
    );
  }

  void _pickLocation() {
    // TODO: Implement Google Maps location picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location picker integration pending')),
    );
  }

  void _submitProperty() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property posted successfully!')),
      );
    }
  }
}
