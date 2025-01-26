import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteCard extends StatelessWidget {
  final String title;
  final String posterPath;
  final String overview;

  const FavoriteCard({
    Key? key,
    required this.title,
    required this.posterPath,
    required this.overview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            ),
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
              width: 100.w,
              height: 150.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 100.w,
                height: 150.h,
                color: Colors.grey.shade300,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100.w,
                height: 150.h,
                color: Colors.grey,
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    overview,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

