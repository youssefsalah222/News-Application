import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/layout/news_app/cubit/cubit.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/observer.dart';
import 'global_cubit/global_cubit.dart';
import 'global_cubit/global_state.dart';
import 'layout/news_app/news_layout.dart';
void main() async
{
  //بيتأكد ان كل حاجة خلصت في الميثود وبعدين يفتح  الابليكيشن
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');

  runApp(MyApp(isDark));
}

class MyApp extends StatelessWidget {

  final bool isDark;
  MyApp(this.isDark);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => NewsCubit()..getBusiness()..getSports()..getScience()),
        BlocProvider(create: (BuildContext context) => globalCubit()..changeMode(fromShared: isDark,)
        ),
      ],
      child: BlocConsumer<globalCubit , globalStates>(
        listener: (context , state) {},
        builder: (context , state) {
          return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backwardsCompatibility: false,      // to control status bar
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,    
              ) ,
              backgroundColor: Colors.white,
              elevation: 0.0,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey,
              elevation: 20.0,
              backgroundColor:Colors.white,
            ), 
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          darkTheme: ThemeData(
             primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: Color.fromRGBO(51, 55, 57, 1),
            appBarTheme: AppBarTheme(
              backwardsCompatibility: false,      // to control status bar
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromRGBO(51, 55, 57, 1),
                statusBarIconBrightness: Brightness.light,    
              ) ,
              backgroundColor: Color.fromRGBO(51, 55, 57, 1),
              elevation: 0.0,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey,
              elevation: 20.0,
              backgroundColor: Color.fromRGBO(51, 55, 57, 1),
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          themeMode: globalCubit.get(context).isDark ? ThemeMode.dark: ThemeMode.light,
          home: NewsLayout(),
        );
        },
      ),
    );
  }
}