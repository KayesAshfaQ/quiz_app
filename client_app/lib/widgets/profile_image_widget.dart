import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? currentImageUrl;
  final bool isLoading;
  final VoidCallback? onEditTap;

  const ProfileImageWidget({
    super.key,
    this.currentImageUrl,
    this.isLoading = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onEditTap,
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
              backgroundImage: currentImageUrl != null && !isLoading
                  ? NetworkImage(currentImageUrl!)
                  : null,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : (currentImageUrl == null
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
