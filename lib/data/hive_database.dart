import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_app/datetime/date_time.dart';
import 'package:workout_app/models/workout.dart';
import '../models/exercise.dart';

class HiveDatabase {
  final _myBox = Hive.box('workout_database');

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print('No previous data found');
      _myBox.put('START_DATE', todayDateYYYYMMDD());
      return false;
    } else {
      print('Previous data found');
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get('START_DATE');
  }

  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS${todayDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS${todayDateYYYYMMDD()}", 0);
    }

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  void deleteFromDatabase(String workoutName) {
    List<Workout> workouts = readFromDatabase();
    workouts.removeWhere((workout) => workout.name == workoutName);
    saveToDatabase(workouts);
  }

  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exerciseInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == 'true' ? true : false,
          ),
        );
      }

      Workout workout =
          Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS$yyyymmdd") ?? 0;

    return completionStatus;
  }
}

List<String> convertObjectToWorkoutList(List<Workout> workoutList) {
  List<String> workoutNameList = [];

  for (Workout workout in workoutList) {
    workoutNameList.add(workout.name);
  }

  return workoutNameList;
}

/*
    [
        Upper Body
        [
            [Bench Press, 100, 10, 3, false],
            [Bicep Curls, 20, 10, 3, false],
        ],
        Lower Body
        [
            [Squats, 100, 10, 3, false],
            [Deadlifts, 100, 10, 3, false],
        ],
    ]
*/
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];

      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
