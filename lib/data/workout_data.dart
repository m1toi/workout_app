import 'package:flutter/material.dart';
import 'package:workout_app/data/hive_database.dart';

import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutData extends ChangeNotifier {

  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(
          name: "Bench Press",
          weight: "135",
          reps: "10",
          sets: "3",
        ),
      ],
    )
  ];

  void initializeWorkoutList(){
    if (db.previousDataExists()){
      workoutList = db.readFromDatabase();
    }
    else{
      db.saveToDatabase(workoutList);
    }
  }

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();

    db.saveToDatabase(workoutList);
  }

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(Exercise(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
    ));

    notifyListeners();

    db.saveToDatabase(workoutList);
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevandExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();

    db.saveToDatabase(workoutList);
  }

  Workout getRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }

  Exercise getRelevandExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
  }
}
