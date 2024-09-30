codeunit 50004 Api
{
    procedure StudentApi(AddmissionNo: Text; StudentName: Text; DOB: Date; ParentName: Text; Address: Text; Pincode: Integer; MobileNo: Text) ResponseMessage: Text
    var
        Student: Record Student; // Define a variable to hold the Student record
    begin
        Clear(Student); // Clear any previous data in the Student record
        Student.SetRange("Addmission No.", AddmissionNo); // Set a filter to find the student by Addmission No.
        if Student.FindFirst() then begin
            // If the student record is found, update the existing record
            Student.Validate(Name, StudentName);
            Student.Validate(DOB, DOB);
            Student.Validate("Parent Name", ParentName);
            Student.Validate(Address, Address);
            Student.Validate(PostalCode, Format(Pincode));
            Student.Validate("Mobile No.", MobileNo);
            Student.Modify(); // Save the changes to the record
            ResponseMessage := 'Record is successfully Modified.'; // Set the response message for modification
        end else begin
            // If the student record is not found, insert a new record
            Clear(Student); // Clear any previous data in the Student record
            Student.Init(); // Initialize a new Student record
            Student.Validate("Addmission No.", AddmissionNo);
            Student.Validate(Name, StudentName);
            Student.Validate(DOB, DOB);
            Student.Validate("Parent Name", ParentName);
            Student.Validate(Address, Address);
            Student.Validate(PostalCode, Format(Pincode));
            Student.Validate("Mobile No.", MobileNo);
            Student.Insert(); // Insert the new record into the table
            ResponseMessage := 'Record is successfully Inserted.'; // Set the response message for insertion
        end;
    end;
}
