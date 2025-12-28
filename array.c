#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int a[100];
int n = 0;
bool isInput = false;

/* Selection Sort giảm dần */
void sortDesc(int a[], int n)
{
    int max, temp;

    for (int i = 0; i < n - 1; i++)
    {
        max = i;

        for (int j = i + 1; j < n; j++)
        {
            if (a[j] > a[max])
            {
                max = j;
            }
        }

        if (max != i)
        {
            temp = a[i];
            a[i] = a[max];
            a[max] = temp;
        }
    }
}

/* Kiểm tra số nguyên tố */
bool isPrime(int x)
{
    if (x <= 1)
        return false;
    for (int i = 2; i < x; i++)
    {
        if (x % i == 0)
            return false;
    }
    return true;
}

int main()
{
    int choice;

    do
    {
        printf("\n================ MENU ================\n");
        printf("1. Input an array\n");
        printf("2. Output the array\n");
        printf("3. Print the array in descending order\n");
        printf("4. Check if all elements are odd\n");
        printf("5. Search a value\n");
        printf("6. Display prime numbers in the array\n");
        printf("7. Quit\n");
        printf("Please select your choice (1-7): ");
        scanf("%d", &choice);

        switch (choice)
        {

        case 1:
        {
            int confirm;

            if (isInput)
            {
                printf("The array already exists.\n");
                printf("Do you want to change all the elements in the array?\n");
                printf("Enter 1 to process: ");
                scanf("%d", &confirm);

                if (confirm != 1)
                {
                    break;
                }
            }

            printf("Number of elements (1-100): ");
            scanf("%d", &n);

            printf("Input each element separated by space:\n");
            for (int i = 0; i < n; i++)
            {
                scanf("%d", &a[i]);
            }

            isInput = true;
            break;
        }

        case 2:
            if (!isInput)
            {
                printf("Please input the array first!\n");
            }
            else
            {
                printf("Here is the array:\n");
                for (int i = 0; i < n; i++)
                {
                    printf("%d ", a[i]);
                }
                printf("\n");
            }
            break;

        case 3:
            if (!isInput)
            {
                printf("Please input the array first!\n");
            }
            else
            {
                sortDesc(a, n);
                printf("Array in descending order:\n");
                for (int i = 0; i < n; i++)
                {
                    printf("%d ", a[i]);
                }
                printf("\n");
            }
            break;

        case 4:
            if (!isInput)
            {
                printf("Please input the array first!\n");
            }
            else
            {
                bool check = true;
                for (int i = 0; i < n; i++)
                {
                    if (a[i] % 2 == 0)
                    {
                        check = false;
                        break;
                    }
                }

                if (check)
                    printf("All elements of the array are odd.\n");
                else
                    printf("Elements of the array are not all odd.\n");
            }
            break;

        case 5:
            if (!isInput)
            {
                printf("Please input the array first!\n");
            }
            else
            {
                int x, count = 0;
                printf("Input the value to search: ");
                scanf("%d", &x);

                for (int i = 0; i < n; i++)
                {
                    if (a[i] == x)
                        count++;
                }

                printf("%d appears in the array %d time(s).\n", x, count);
            }
            break;

        case 6:
            if (!isInput)
            {
                printf("Please input the array first!\n");
            }
            else
            {
                int b[100];
                int k = 0;

                for (int i = 0; i < n; i++)
                {
                    if (isPrime(a[i]))
                    {
                        b[k++] = a[i];
                    }
                }

                if (k == 0)
                {
                    printf("There is no prime element in the array.\n");
                }
                else
                {
                    printf("List of prime elements:\n");
                    for (int i = 0; i < k; i++)
                    {
                        printf("%d ", b[i]);
                    }
                    printf("\n");
                }
            }
            break;

        case 7:
        {
            int e;
            int c;

            printf("Are you sure? Enter 1 to exit the application: ");
            if (scanf("%d", &e) != 1)
            {
                // Xóa buffer để tránh lặp vô hạn
                while ((c = getchar()) != '\n' && c != EOF);

                break; // quay lại menu
            }

            if (e == 1)
            {
                exit(0);
            }
            // khác 1 thì quay lại menu
            break;
        }

        default:
            printf("Invalid choice! Please choose from 1 to 7.\n");
        }

    } while (1);

    return 0;
}
