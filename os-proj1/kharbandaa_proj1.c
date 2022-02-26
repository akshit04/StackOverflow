#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

/*
This program provides a possible solution for multi producer/consumer problem using mutex and semaphore.
Number of producers and consumers will be taken as an input to demonstrate the solution.
*/

sem_t empty;    // Semaphore to keep track of empty/available spaces in the buffer.
sem_t full;     // Sempahore to keep track of full/used spaces in the buffer.
int in = 0;     // An index used by producers to keep track of resources in the buffer (to produce the resources).
int out = 0;    // An index used by consumers to keep track of resources in the buffer (to consume the resources).
int *buffer;    // An integer array to store the resources.
int MaxItems;   // Maximum items a producer can produce or a consumer can consume.
int BufferSize; // Size of the buffer.
pthread_mutex_t mutex;  // Declaring the mutex to acquire the locks.
long ltime;

void *producer(void *pno) {   
    int item;
    for(int i = 0; i < MaxItems; i++) {
        item = rand(); // Produce a random item
        sem_wait(&empty);   // decrease the value of empty by 1, because we are adding (producing) a resource.
        pthread_mutex_lock(&mutex);     // Producer locks the mutex before entering the Critical Section.
        buffer[in] = item;  // Add the produced item to the buffer
        ltime = time(NULL);
        printf("Producer %d: Insert Item %d at index %d || %s\n", *((int *)pno), buffer[in], in, asctime(localtime(&ltime)));
        usleep((rand() % 40) * 10000);  // sleeping inorder to prevent starvation (fair play for all producers and consumers)
        in = (in+1)%BufferSize;     // set the buffer index for the next resource to be stored in the buffer.
        pthread_mutex_unlock(&mutex);   // Producer unlocks the mutex after exiting the critical section.
        sem_post(&full);    // increase the value of full by 1, because we are adding (producing) a resource.
    }
}

void *consumer(void *cno) {   
    for(int i = 0; i < MaxItems; i++) {
        sem_wait(&full);    // decrease the value of full by 1, because we are removing (comsuming) a resource.
        pthread_mutex_lock(&mutex);     // Consumer locks the mutex before entering the Critical Section.
        int item = buffer[out];     // Consuming the resource stored at buffer[out].
        ltime = time(NULL);
        printf("Consumer %d: Remove Item %d from %d || %s\n",*((int *)cno), item, out, asctime(localtime(&ltime)));
        usleep((rand() % 40) * 10000);      // sleeping inorder to prevent starvation (fair play for all producers and consumers)
        out = (out+1)%BufferSize;       // set the buffer index for the next resource to be stored in the buffer.
        pthread_mutex_unlock(&mutex);   // Consumer unlocks the mutex after exiting the critical section.
        sem_post(&empty);      // increase the value of empty by 1, because we are removing (comsuming) a resource.
    }
}

int main() {
    // printf("Please enter the number of Producers and Consumers (an integer value greater than 3).\n");
    // scanf("%d", &MaxItems);
    MaxItems = 5;
    BufferSize = MaxItems;

    printf("Number of Producers: %d\n", MaxItems);
    printf("Number of Consumers: %d\n", MaxItems);
    printf("Buffer size: %d\n\n", BufferSize);

    buffer = malloc( sizeof(int)*BufferSize);   // allocate the memory to buffer array of size BufferSize.
    if(buffer == NULL) {
        printf("Exiting! Memory allocation falied.\n");
        return 0;
    }

    pthread_t pro[MaxItems], con[MaxItems];
    pthread_mutex_init(&mutex, NULL);
    sem_init(&empty, 0, BufferSize);
    sem_init(&full, 0, 0);

    int a[MaxItems];    // Assign the numbers to producers and consumers
    for(int i = 1; i <= MaxItems; i++) {
        a[i-1] = i;
    }

    // Creating threads for each producer.
    for(int i = 0; i < MaxItems; i++) {
        pthread_create(&pro[i], NULL, (void *)producer, (void *)&a[i]);
    }

    // Creating threads for each comsumer.
    for(int i = 0; i < MaxItems; i++) {
        pthread_create(&con[i], NULL, (void *)consumer, (void *)&a[i]);
    }

    for(int i = 0; i < MaxItems; i++) {
        pthread_join(pro[i], NULL);
    }

    for(int i = 0; i < MaxItems; i++) {
        pthread_join(con[i], NULL);
    }


    // Destroy and Free all the memory.
    pthread_mutex_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);
    free(buffer);

    return 0;
}
