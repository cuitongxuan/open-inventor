#!/bin/ksh

# Shell script to generate the stuff that is the same for all
# multiple-value fields (generated by the macros in SoSubField.h)

if test $# -ne 3 ; then
	echo "Usage: " $0 " className valueType valueRef"
	echo "  e.g: " $0 " SoSFShort short short"
	echo "  e.g: " $0 " SoSFColor SbColor 'const SbColor &'"
	exit
fi

className=$1
valueType=$2
valueRef=$3

cat <<EOF
METHOD "" static SoType getClassTypeId() {}
METHOD "" virtual void getTypeId() const {
Returns the type for this class or a particular object of this class.
}
METHOD Get $valueRef operator[](int i) const {
Returns the i'th value of the field.  Indexing past the end of the
field (passing in i greater than getNum()) will return garbage.
}
METHOD GetN const $valueType * getValues(int start) const {
Returns a pointer into the array of values in the field, starting at
index start.  The values are read-only; see the
startEditing/finishEditing methods for a way of modifying values
in-place.
}
METHOD "" int find($valueRef targetValue,
	SbBool addIfNotFound = FALSE) {
Finds the given value in the array and returns the index of that value
in the array.  If the value is not found, -1 is returned.  If
addIfNotFound is set, then targetValue will be added to the end of the
array (but -1 is still returned).
}
METHOD SetN void setValues(int start, int num,
	const $valueType *newValues) {
Sets num values starting at index start to the values in newValues.
The array will be automatically be made larger to accomodate the new
values, if necessary.
}
METHOD Set1 void set1Value(int index, $valueRef newValue) {
Sets the index'th value in the array to newValue.  The array will be
automatically expanded, if necessary.
}
METHOD " " $valueRef operator=($valueRef newValue) {}
METHOD Set void setValue($valueRef newValue) {
Sets the first value in the array to newValue, and deletes the second
and subsequent values.
}
METHOD IsEq int operator==(const $className &f) const {}
METHOD IsNEq int operator!=(const $className &f) const {
Returns TRUE if all of the values of this field equals (does not
equal) the given field.  If the fields are different types FALSE will
always be returned (even if one field is an \cSoMFFloat\. with one
value of 1.0 and the other is an \cSoMFInt\. with a value of 1, for
example).
}
METHOD StartEdit $valueType *startEditing() {}
METHOD FinishEdit void finishEditing() {
startEditing() returns a pointer to the internally-maintained array that can be
modified.  The values in the array may be changed, but values cannot
be added or removed.
It is illegal to call any other editing
methods are called between 
\+
startEditing() and finishEditing() (e.g.
set1Value(), setValue(), etc).
\.
\-
StartEdit() and FinishEdit() (e.g. Set1(), Set(), etc).
\.
\p
Fields, engines or sensors connected to this field and sensors are not
notified that this field has changed until 
\+finishEditing()\. \-FinishEdit()\. is called.  Calling
\+finishEditing()\. \-FinishEdit()\. always sets the
\+isDefault()\. \-IsDflt\. flag to FALSE and informs
engines and sensors that the field changed, even if none of the values
actually were changed.
}
EOF

