import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/global_cubit/global_state.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';

class globalCubit extends Cubit<globalStates>
{
  globalCubit() : super(globalInitialState());
   static globalCubit get(context) => BlocProvider.of(context);
  
  bool isDark = false;

  void changeMode({bool fromShared})
  {
    if(fromShared != null)
    {
    isDark = fromShared;
    emit(changeModeState());
    }
    else
    {
    isDark = !isDark;

    CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
      
      emit(changeModeState());
    });
    }
  } 
}