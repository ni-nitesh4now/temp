int main() {
    printf("Running basic test 1: Simple allocation and deallocation\n");

    char *ptr = (char *)malloc(100);
    free(ptr);

    return 0;
}
