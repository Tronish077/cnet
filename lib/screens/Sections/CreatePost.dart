import 'dart:io';
import 'package:cnet/BackendFuncs/MainBackend.dart';
import 'package:cnet/CustomWidgets/customeWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final FocusNode _dummyFocusNode = FocusNode();
  final CustomWidgets _custom = CustomWidgets();

  final List<String> categories = [
    'Electronics & Computers',
    'Mobile Phones',
    'Furniture',
    'Video Games',
    'Jewellery & Accessories',
    'Bags and luggage',
    "Men's Clothing and shoes" ,
    "Women's Clothing and shoes",
    'Unisex',
    'Academics',
    'Health & beauty',
    'Womens',
    'Services',
    'Miscellaneous',
  ];

  final List<String> conditions = [
    "Brand New",
    "Used-Fair",
    "Used-Good",
  ];
  List<XFile> _pickedImages = [];
  final List<String> _tags = [];

  String? _selectedCategory = 'Miscellaneous';
  String? _selectedCondition = 'Brand New';
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

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _contactController.clear();
    _locationController.clear();
    _tagController.clear();

    setState(() {
      _tags.clear();
      _pickedImages.clear();
      _selectedCategory = 'Services';
      _selectedCondition = 'New';
      _selectedStatus = 'Available';
    });

    FocusScope.of(context).unfocus();
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

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      _custom.LoaderSpinner(context);
      await uploadListing(
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
      ).then((_) {
        // 🧹 Clear form after successful upload
        FocusScope.of(context).unfocus();
        clearForm();
        Navigator.pop(context);

        // ✅ Show confirmation if needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing submitted successfully!')),
        );
      });
    }
  }

  Future<void> _selectCategory() async {
    FocusScope.of(context).requestFocus(_dummyFocusNode);
    final selected = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // makes it full height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6, // 60% of screen height
          minChildSize: 0.4,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Small drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return ListTile(
                        title: Text(cat),
                        trailing: _selectedCategory == cat
                            ? Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () => Navigator.pop(context, cat),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );


    if (selected != null) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  Future<void> _selectCondition() async {
    FocusScope.of(context).requestFocus(_dummyFocusNode);
    final selected = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // makes it full height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4, // 60% of screen height
          minChildSize: 0.2,
          maxChildSize: 0.7,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Small drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text("Select Condition", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: conditions.length,
                    itemBuilder: (context, index) {
                      final cond = conditions[index];
                      return ListTile(
                        title: Text(cond),
                        trailing: _selectedCondition == cond
                            ? Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () => Navigator.pop(context, cond),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCondition = selected;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(250, 61, 42, 234)
              ),
              onPressed: _submitForm,
              icon: Icon(FontAwesomeIcons.upload,color: Colors.white
                ,),
              label:Text("Publish",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
        title: const Text("Create Listing",style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20
        ),),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image picker
                const SizedBox(height: 10),
                _pickedImages.isNotEmpty ?
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _pickedImages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children:[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                              File(_pickedImages[index].path),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                                                      ),
                            ),
                            Positioned(
                              right:8,
                              top:8,
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _pickedImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white
                                  ),
                                  child: Icon(Icons.delete_outline_sharp,color: Colors.red),
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                    ),
                  ) :
                GestureDetector(
                  onTap:_pickImages,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:Color.fromARGB(20, 61, 42, 234)),
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Add Photo Button
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(70, 61, 42, 234),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: IconButton(
                              onPressed: _pickImages,
                              icon: const Icon(FontAwesomeIcons.images,
                                color: Color.fromARGB(196, 61, 42, 234),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Add Photos",style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Title
                _custom.textBoxCustom(_titleController, "Title", "Enter a title",Icons.edit),
                SizedBox(height: 16),

                // Price
                _custom.textBoxCustom(_priceController, "Price", "Enter a price",Icons.price_change_rounded),
                SizedBox(height: 16),

                // Contact
                _custom.textBoxCustom(_contactController, "Contact", "Enter a contact",Icons.contact_phone_rounded),
                SizedBox(height: 16),
                // Location
                _custom.textBoxCustom(_locationController, "Hostel / Active Location", "Enter Location",Icons.location_on),

                const SizedBox(height: 16),

                // Category Dropdown
                InkWell(
                  onTap: _selectCondition,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Condition",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _selectedCondition ?? "Select a condition",
                      style: TextStyle(
                        color: _selectedCondition == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Condition Dropdown
                InkWell(
                  onTap: _selectCategory,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _selectedCategory ?? "Select a category",
                      style: TextStyle(
                        color: _selectedCategory == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // // Status Dropdown
                // DropdownButtonFormField(
                //   value: _selectedStatus,
                //   decoration: const InputDecoration(labelText: "Status"),
                //   items: const [
                //     DropdownMenuItem(value: 'Available', child: Text("Available")),
                //     DropdownMenuItem(value: 'Sold', child: Text("Sold")),
                //   ],
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedStatus = value!;
                //     });
                //   },
                // ),
                // SizedBox(height: 8),

                // Description
                _custom.textBoxCustom(_descriptionController, "Description", "Enter Item Description",Icons.description_rounded,maxLines: null),
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
