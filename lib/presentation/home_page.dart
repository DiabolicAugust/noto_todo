import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 35.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              // height: 48.h
            ),
            displayMedium: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.lineThrough,
              // height: 33.h,
              color: const Color.fromARGB(
                255,
                156,
                156,
                156,
              ),
            ),
            displaySmall: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        home: Builder(builder: (context) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                children: [
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/moon.svg',
                        ),
                        SvgPicture.asset(
                          'assets/cofe.svg',
                        ),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 44.h,
                        child: Text(
                          'TODAY',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      SizedBox(
                        height: 33.h,
                        child: Text(
                          'TOMORROW',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                    ],
                  ),
                  59.verticalSpace,
                  SizedBox(
                    height: 500.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0.h),
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                      itemCount: 4,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Add a new task',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
