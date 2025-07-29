import 'dart:io';
import 'package:cnet/BackendFuncs/MainBackend.dart';
import 'package:flutter/material.dart';
import '../../FunctionClasses/imageUpload.dart';
import 'package:image_picker/image_picker.dart';

class PostListingPage extends StatefulWidget {
  const PostListingPage({super.key});

  @override
  State<PostListingPage> createState() => _PostListingPageState();
}

class _PostListingPageState extends State<PostListingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final List<String> categories = [
    'Services',
    'Furniture',
    'Electronics',
    'Womenswear',
    'Menswear'
  ];

  List<XFile> _pickedImages = [];
  final List<String> _tags = [];

  String _selectedCategory = 'Services';
  String _selectedCondition = 'New';
  String _selectedStatus = 'Available';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _pickedImages = images;
      });
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      uploadListing(
        _pickedImages,
        _titleController.text,
        _contactController.text,
        _tags,
        _selectedStatus,
        _locationController.text,
        _selectedCondition,
        _priceController.text,
        _descriptionController.text,
        _selectedCategory,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Listing"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value!.isEmpty ? "Enter a title" : null,
              ),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter a price" : null,
              ),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => value!.isEmpty ? "Enter a description" : null,
              ),

              // Contact
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: "Contact"),
                validator: (value) => value!.isEmpty ? "Enter a contact" : null,
              ),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),

              const SizedBox(height: 12),

              // Category Dropdown
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: "Category"),
                items: categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              // Condition Dropdown
              DropdownButtonFormField(
                value: _selectedCondition,
                decoration: const InputDecoration(labelText: "Condition"),
                items: const [
                  DropdownMenuItem(value: 'New', child: Text("New")),
                  DropdownMenuItem(value: 'Used', child: Text("Used")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),

              // Status Dropdown
              DropdownButtonFormField(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: 'Available', child: Text("Available")),
                  DropdownMenuItem(value: 'Sold', child: Text("Sold")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),

              const SizedBox(height: 12),

              // Tags
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(labelText: "Add Tag"),
                    ),
                  ),
                  IconButton(
                    onPressed: _addTag,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: _tags
                    .map((tag) => Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => setState(() => _tags.remove(tag)),
                ))
                    .toList(),
              ),

              const SizedBox(height: 16),

              // Image picker
              OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.image),
                label: const Text("Select Images"),
              ),
              const SizedBox(height: 10),
              if (_pickedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pickedImages.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(_pickedImages[index].path),
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit Listing"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
