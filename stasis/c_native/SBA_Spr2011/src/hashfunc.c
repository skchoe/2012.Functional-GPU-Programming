#include<stdio.h>
#include<ctype.h>

int get_hash_from_char_host(char c){
	if (isalpha(c)){
		if (isupper(c)){
			return tolower(c) - 'a' + 26;
		} else {
			return c - 'a';
		}
	} 
	return -1;
}

int hashfunc_host(char *to){
	int v1 = get_hash_from_char_host(*to);
	if (v1 == -1) return -1;
	if ( isblank(*(to+1)) || *(to+1) == '\0')
	{
		return v1;
	}
	
       	int v2 = get_hash_from_char_host(*(to+1));
	if (v2 == -1) return -1;

       	return (1+v1)*2*26 + v2;
}


/*


int main(){
	printf ("%d %d \n", 'a', 'A');
	char * a = "a " ;
	printf("%d\n",hashfunc_host(a));
	char * b = "A ";
	printf("%d\n",hashfunc_host(b));
	char * c = "Aa";
	printf("%d\n",hashfunc_host(c));
	char * d = "aa";
	printf("%d\n",hashfunc_host(d));
}

*/
