import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/profile_provider.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/services/profile_repository.dart';
import 'package:quiz_app/utils/image_picker_util.dart';

class ProfileImageWidget extends StatefulWidget {
  final String? currentImageUrl;
  final String userId;
  final ProfileRepository? profileRepository;

  const ProfileImageWidget({
    super.key,
    this.currentImageUrl,
    required this.userId,
    this.profileRepository,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  bool _isLoading = false;
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();
  late final ProfileRepository _profileRepository;

  @override
  void initState() {
    super.initState();
    _profileRepository =
        widget.profileRepository ??
        ProfileRepository(firestoreService: FirestoreService());
  }

  Future<void> _updateProfileImage(ImageSource source) async {
    try {
      final file = await _imagePickerUtil.pickImage(source: source);
      if (file == null) return;

      setState(() {
        _isLoading = true;
      });

      await _profileRepository.uploadProfileImage(
        userId: widget.userId,
        imageFile: file,
      );

      if (!mounted) return;
      await context.read<ProfileProvider>().loadUserProfile(widget.userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully.')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.of(context).pop();
                _updateProfileImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _updateProfileImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _showImageSourceDialog,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFFF0EFFF),
              backgroundImage: widget.currentImageUrl != null && !_isLoading
                  ? NetworkImage(widget.currentImageUrl!)
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : (widget.currentImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF6B58E9),
                          )
                        : null),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF6B58E9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
