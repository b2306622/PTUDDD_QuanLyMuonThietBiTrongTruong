import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../viewmodels/device_provider.dart';
import 'package:uuid/uuid.dart';

class AdminDevicePage extends StatefulWidget {
  const AdminDevicePage({super.key});

  @override
  State<AdminDevicePage> createState() => _AdminDevicePageState();
}

class _AdminDevicePageState extends State<AdminDevicePage> {
  void _showDeviceDialog([Device? device]) {
    final isEditing = device != null;
    final nameController = TextEditingController(text: isEditing ? device.name : '');
    final categoryController = TextEditingController(text: isEditing ? device.category : '');
    final descriptionController = TextEditingController(text: isEditing ? device.description : '');
    final imageUrlController = TextEditingController(text: isEditing ? device.imageUrl : 'https://via.placeholder.com/150');
    bool isNew = isEditing ? device.isNew : false;
    String status = isEditing ? device.status : 'available';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Sửa thiết bị' : 'Thêm thiết bị mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Tên thiết bị'),
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Danh mục'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Mô tả'),
                    ),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(labelText: 'URL Hình ảnh'),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      decoration: const InputDecoration(labelText: 'Trạng thái'),
                      items: const [
                        DropdownMenuItem(value: 'available', child: Text('Có sẵn')),
                        DropdownMenuItem(value: 'unavailable', child: Text('Không có sẵn')),
                        DropdownMenuItem(value: 'borrowed', child: Text('Đã mượn')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          status = val!;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Là thiết bị mới?'),
                      value: isNew,
                      onChanged: (val) {
                        setState(() {
                          isNew = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newDevice = Device(
                      id: isEditing ? device.id : const Uuid().v4(),
                      name: nameController.text,
                      category: categoryController.text,
                      description: descriptionController.text,
                      imageUrl: imageUrlController.text,
                      status: status,
                      isNew: isNew,
                    );
                    if (isEditing) {
                      Provider.of<DeviceProvider>(context, listen: false).updateDevice(newDevice);
                    } else {
                      Provider.of<DeviceProvider>(context, listen: false).addDevice(newDevice);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final devices = deviceProvider.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thiết bị (Admin)'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeviceDialog(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            leading: Image.network(
              device.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
            ),
            title: Text(device.name),
            subtitle: Text('${device.category} - ${device.status}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showDeviceDialog(device),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: Text('Bạn có chắc muốn xóa ${device.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              deviceProvider.deleteDevice(device.id);
                              Navigator.pop(context);
                            },
                            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
