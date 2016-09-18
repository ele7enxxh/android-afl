#ifndef _ANDROID_ASHMEM_H
#define _ANDROID_ASHMEM_H

#include <fcntl.h>
#include <linux/shm.h>
#include <linux/ashmem.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

#include <stdio.h>

#define ASHMEM_DEVICE	"/dev/ashmem"

static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
{
		int ret = 0;
		if (__cmd == IPC_RMID) {
			int length = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
			struct ashmem_pin pin = {0, length};
			ret = ioctl(__shmid, ASHMEM_UNPIN, &pin);
			close(__shmid);
		}

		return ret;
}

static inline int shmget (key_t __key, size_t __size, int __shmflg)
{
	int fd,ret;
	char key[11];

	fd = open(ASHMEM_DEVICE, O_RDWR);
	if (fd < 0)
		return fd;

	sprintf(key,"%d",__key);
	ret = ioctl(fd, ASHMEM_SET_NAME, key);
	if (ret < 0)
		goto error;

	ret = ioctl(fd, ASHMEM_SET_SIZE, __size);
	if (ret < 0)
		goto error;

	return fd;

error:
	close(fd);
	return ret;
}

static inline void *shmat (int __shmid, const void *__shmaddr, int __shmflg)
{
  int size;
  void *ptr;
  
  size = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
  if (size < 0) {
    return NULL;
  }

  ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, __shmid, 0);
  if (ptr == MAP_FAILED) {
    return NULL;
  }
  
  return ptr;
}

#endif
