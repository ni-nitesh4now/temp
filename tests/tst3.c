int main() {
    printf("Running custom test 3: Allocating and freeing memory with different sizes\n");

    char *ptr1 = (char *)malloc(100);
    char *ptr2 = (char *)malloc(200);
    char *ptr3 = (char *)malloc(300);

    free(ptr1);
    free(ptr2);
    free(ptr3);

    return 0;
}
