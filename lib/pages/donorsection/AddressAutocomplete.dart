import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressAutocomplete extends StatefulWidget {
  final TextEditingController addressController;
  final ValueNotifier<double> latNotifier;
  final ValueNotifier<double> lngNotifier;

  const AddressAutocomplete({
    super.key,
    required this.addressController,
    required this.latNotifier,
    required this.lngNotifier,
  });

  @override
  _AddressAutocompleteState createState() => _AddressAutocompleteState();
}

class _AddressAutocompleteState extends State<AddressAutocomplete> {
  List<dynamic> suggestions = [];
  bool isLoading = false;

  Future<void> fetchAddressSuggestions(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final String apiUrl =
        "https://api.geoapify.com/v1/geocode/autocomplete?text=$query&format=json&apiKey=8a0ea6cf319c40f3b666b782d4dde510";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          suggestions = data['results'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch suggestions");
      }
    } catch (e) {
      setState(() {
        suggestions = [];
        isLoading = false;
      });
      print("Error fetching address suggestions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.addressController,
          decoration: InputDecoration(
            labelText: "Address",
            suffixIcon: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Icon(Icons.location_on),
          ),
          onChanged: (value) {
            fetchAddressSuggestions(value);
          },
        ),
        const SizedBox(height: 8),
        if (suggestions.isNotEmpty)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion['formatted']),
                  onTap: () {
                    String selectedAddress = suggestion['formatted'];
                    double latitude = suggestion['lat'];
                    double longitude = suggestion['lon'];

                    // Update the text field and notify listeners
                    widget.addressController.text = selectedAddress;
                    widget.latNotifier.value = latitude;
                    widget.lngNotifier.value = longitude;

                    setState(() {
                      suggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
