//
//
//
// class ApiResponse <T>{ // it is a generic class
//
//   Status ? status;
//   T? data;
//   String ? message;
//
//   ApiResponse(this.status,this.data,this.message);
//
//   ApiResponse.loading() :status= Status.LOADING; // it is named constructur . like constructer overloading
//   ApiResponse.completed(this.data) :status= Status.Completed; // : this initalize the varable before the {}
//   ApiResponse.error(this.message) :status= Status.ERROR;
//
//   @override
//   String toString(){
//     return "Status :$status \n Message :$message \n Data :$data";
//   }// when we print obj it say instance of onj. so we overdie when obj print whta show
//
//
// }