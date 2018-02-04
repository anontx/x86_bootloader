
#define VIDEO_MEMORY 0xb8000

void print(char *msg)
{
    char *p_video_buffer = (char *)VIDEO_MEMORY;
    char *p_next_char = msg;

    while(*p_next_char)
    {
        *p_video_buffer = *p_next_char;
        p_next_char++;
        p_video_buffer += 2;
    }
}


void kmain()
{
  print("Executing our C kernel");

  while(1) {}
}

