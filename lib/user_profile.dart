import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String fanSpeed;
  final String idealTemperature;

  UserProfile({
    required this.name,
    required this.fanSpeed,
    required this.idealTemperature,
  });
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final List<UserProfile> _userProfiles = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  String _selectedFanSpeed = '1';
  String _selectedUsername = ''; // Added to store selected username

  void _saveUserProfile() {
    final String name = _nameController.text;
    final String idealTemperature = _temperatureController.text;

    if (name.isEmpty || idealTemperature.isEmpty) {
      return;
    }

    final UserProfile newUserProfile = UserProfile(
      name: name,
      fanSpeed: _selectedFanSpeed,
      idealTemperature: idealTemperature,
    );

    setState(() {
      _userProfiles.add(newUserProfile);
    });

    _nameController.clear();
    _temperatureController.clear();
    _selectedFanSpeed = '1';
  }

  void _showUserDetails(UserProfile userProfile) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(userProfile.name),
          content: Text(
              'Fan Speed: ${userProfile.fanSpeed}\nIdeal Temperature: ${userProfile.idealTemperature}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedUsername = userProfile.name; // Update selected username
                });
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profiles'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _temperatureController,
              decoration: InputDecoration(
                labelText: 'Ideal Temperature in °C',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Fan Speed:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFanSpeed,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFanSpeed = newValue!;
                    });
                  },
                  items: <String>['1', '2', '3', 'Max']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserProfile,
              child: Text('Save User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Available User Profiles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _userProfiles.length,
                itemBuilder: (context, index) {
                  final UserProfile userProfile = _userProfiles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(userProfile.name),
                      subtitle: Text(
                          'Fan Speed: ${userProfile.fanSpeed}, Ideal Temperature : ${userProfile.idealTemperature}'),
                      onTap: () => _showUserDetails(userProfile),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.deepPurpleAccent,
          child: Text(
            _selectedUsername.isNotEmpty
                ? 'Selected Profile : $_selectedUsername'
                : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
