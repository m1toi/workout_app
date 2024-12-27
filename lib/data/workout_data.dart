import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutData {
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

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
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
  }

  Workout getRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }
}
