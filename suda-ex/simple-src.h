
typedef struct Date {
float day;
char month;
float year;
} Date;
void make_Date (float day4183 , char month4184 , float year4185 , Date* Date4186 ) {
	Date4186->day = day4183;
	Date4186->month = month4184;
	Date4186->year = year4185;

};
float* Date_day (Date* Date4209) {
	float* day4210 = Date4209->day;
	return day4210;
}
char* Date_month (Date* Date4217) {
	char* month4218 = Date4217->month;
	return month4218;
}
float* Date_year (Date* Date4239) {
	float* year4240 = Date4239->year;
	return year4240;
}
