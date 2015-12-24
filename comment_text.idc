#include <idc.idc>

static main(void)
{
   auto     source;
   auto     comment;
   auto     ea;
   auto     count;
   auto y;
   auto x;

   source = AskStr("", "Enter target string:\n");

   if (source != 0)
{
   comment = AskStr("", "Enter comment string:\n");
  
if (comment != 0)
{
      ea = 0;
      y = 0;
      x = 0;      
      while (1) 
      { 	           
ea = FindText(ea, 7,  y, x, source); 
           					 	  
          if( ea == BADADDR) 
          {
              break;
          }
          MakeComm(ea, comment);
          count++;
          ea++;
          y = 0; x = 0;
          Message("Find target by addres %x\n", ea);	
      }
      Message("%d items find", count);

   Warning("Done");
}
}
}