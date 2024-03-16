int main() {
    printf("Running basic test 2: Reallocating memory\n");

    char *ptr = (char *)malloc(100);
    ptr = (char *)realloc(ptr, 200);

    free(ptr);

    return 0;
}
