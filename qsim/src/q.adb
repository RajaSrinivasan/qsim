
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

with hex ;

package body q is

   crc_table : constant array(1..256) of Unsigned_32 := (
                                                  16#00000000# ,
 16#77073096# ,  16#ee0e612c# ,  16#990951ba# ,  16#076dc419# ,  16#706af48f# ,  16#e963a535# ,  16#9e6495a3# ,  16#0edb8832# ,
 16#79dcb8a4# ,  16#e0d5e91e# ,  16#97d2d988# ,  16#09b64c2b# ,  16#7eb17cbd# ,  16#e7b82d07# ,  16#90bf1d91# ,  16#1db71064# ,
 16#6ab020f2# ,  16#f3b97148# ,  16#84be41de# ,  16#1adad47d# ,  16#6ddde4eb# ,  16#f4d4b551# ,  16#83d385c7# ,  16#136c9856# ,
 16#646ba8c0# ,  16#fd62f97a# ,  16#8a65c9ec# ,  16#14015c4f# ,  16#63066cd9# ,  16#fa0f3d63# ,  16#8d080df5# ,  16#3b6e20c8# ,
 16#4c69105e# ,  16#d56041e4# ,  16#a2677172# ,  16#3c03e4d1# ,  16#4b04d447# ,  16#d20d85fd# ,  16#a50ab56b# ,  16#35b5a8fa# ,
 16#42b2986c# ,  16#dbbbc9d6# ,  16#acbcf940# ,  16#32d86ce3# ,  16#45df5c75# ,  16#dcd60dcf# ,  16#abd13d59# ,  16#26d930ac# ,
 16#51de003a# ,  16#c8d75180# ,  16#bfd06116# ,  16#21b4f4b5# ,  16#56b3c423# ,  16#cfba9599# ,  16#b8bda50f# ,  16#2802b89e# ,
 16#5f058808# ,  16#c60cd9b2# ,  16#b10be924# ,  16#2f6f7c87# ,  16#58684c11# ,  16#c1611dab# ,  16#b6662d3d# ,  16#76dc4190# ,
 16#01db7106# ,  16#98d220bc# ,  16#efd5102a# ,  16#71b18589# ,  16#06b6b51f# ,  16#9fbfe4a5# ,  16#e8b8d433# ,  16#7807c9a2# ,
 16#0f00f934# ,  16#9609a88e# ,  16#e10e9818# ,  16#7f6a0dbb# ,  16#086d3d2d# ,  16#91646c97# ,  16#e6635c01# ,  16#6b6b51f4# ,
 16#1c6c6162# ,  16#856530d8# ,  16#f262004e# ,  16#6c0695ed# ,  16#1b01a57b# ,  16#8208f4c1# ,  16#f50fc457# ,  16#65b0d9c6# ,
 16#12b7e950# ,  16#8bbeb8ea# ,  16#fcb9887c# ,  16#62dd1ddf# ,  16#15da2d49# ,  16#8cd37cf3# ,  16#fbd44c65# ,  16#4db26158# ,
 16#3ab551ce# ,  16#a3bc0074# ,  16#d4bb30e2# ,  16#4adfa541# ,  16#3dd895d7# ,  16#a4d1c46d# ,  16#d3d6f4fb# ,  16#4369e96a# ,
 16#346ed9fc# ,  16#ad678846# ,  16#da60b8d0# ,  16#44042d73# ,  16#33031de5# ,  16#aa0a4c5f# ,  16#dd0d7cc9# ,  16#5005713c# ,
 16#270241aa# ,  16#be0b1010# ,  16#c90c2086# ,  16#5768b525# ,  16#206f85b3# ,  16#b966d409# ,  16#ce61e49f# ,  16#5edef90e# ,
 16#29d9c998# ,  16#b0d09822# ,  16#c7d7a8b4# ,  16#59b33d17# ,  16#2eb40d81# ,  16#b7bd5c3b# ,  16#c0ba6cad# ,  16#edb88320# ,
 16#9abfb3b6# ,  16#03b6e20c# ,  16#74b1d29a# ,  16#ead54739# ,  16#9dd277af# ,  16#04db2615# ,  16#73dc1683# ,  16#e3630b12# ,
 16#94643b84# ,  16#0d6d6a3e# ,  16#7a6a5aa8# ,  16#e40ecf0b# ,  16#9309ff9d# ,  16#0a00ae27# ,  16#7d079eb1# ,  16#f00f9344# ,
 16#8708a3d2# ,  16#1e01f268# ,  16#6906c2fe# ,  16#f762575d# ,  16#806567cb# ,  16#196c3671# ,  16#6e6b06e7# ,  16#fed41b76# ,
 16#89d32be0# ,  16#10da7a5a# ,  16#67dd4acc# ,  16#f9b9df6f# ,  16#8ebeeff9# ,  16#17b7be43# ,  16#60b08ed5# ,  16#d6d6a3e8# ,
 16#a1d1937e# ,  16#38d8c2c4# ,  16#4fdff252# ,  16#d1bb67f1# ,  16#a6bc5767# ,  16#3fb506dd# ,  16#48b2364b# ,  16#d80d2bda# ,
 16#af0a1b4c# ,  16#36034af6# ,  16#41047a60# ,  16#df60efc3# ,  16#a867df55# ,  16#316e8eef# ,  16#4669be79# ,  16#cb61b38c# ,
 16#bc66831a# ,  16#256fd2a0# ,  16#5268e236# ,  16#cc0c7795# ,  16#bb0b4703# ,  16#220216b9# ,  16#5505262f# ,  16#c5ba3bbe# ,
 16#b2bd0b28# ,  16#2bb45a92# ,  16#5cb36a04# ,  16#c2d7ffa7# ,  16#b5d0cf31# ,  16#2cd99e8b# ,  16#5bdeae1d# ,  16#9b64c2b0# ,
 16#ec63f226# ,  16#756aa39c# ,  16#026d930a# ,  16#9c0906a9# ,  16#eb0e363f# ,  16#72076785# ,  16#05005713# ,  16#95bf4a82# ,
 16#e2b87a14# ,  16#7bb12bae# ,  16#0cb61b38# ,  16#92d28e9b# ,  16#e5d5be0d# ,  16#7cdcefb7# ,  16#0bdbdf21# ,  16#86d3d2d4# ,
 16#f1d4e242# ,  16#68ddb3f8# ,  16#1fda836e# ,  16#81be16cd# ,  16#f6b9265b# ,  16#6fb077e1# ,  16#18b74777# ,  16#88085ae6# ,
 16#ff0f6a70# ,  16#66063bca# ,  16#11010b5c# ,  16#8f659eff# ,  16#f862ae69# ,  16#616bffd3# ,  16#166ccf45# ,  16#a00ae278# ,
 16#d70dd2ee# ,  16#4e048354# ,  16#3903b3c2# ,  16#a7672661# ,  16#d06016f7# ,  16#4969474d# ,  16#3e6e77db# ,  16#aed16a4a# ,
 16#d9d65adc# ,  16#40df0b66# ,  16#37d83bf0# ,  16#a9bcae53# ,  16#debb9ec5# ,  16#47b2cf7f# ,  16#30b5ffe9# ,  16#bdbdf21c# ,
 16#cabac28a# ,  16#53b39330# ,  16#24b4a3a6# ,  16#bad03605# ,  16#cdd70693# ,  16#54de5729# ,  16#23d967bf# ,  16#b3667a2e# ,
 16#c4614ab8# ,  16#5d681b02# ,  16#2a6f2b94# ,  16#b40bbe37# ,  16#c30c8ea1# ,  16#5a05df1b# ,  16#2d02ef8d# ) ;

   function Version return String is
   begin
      return "0.1" ;

   end Version ;

   procedure Set( pkt : out QpacketType ; pktb : QpktElementsType ) is
      pktoute : QpktElementsType ;
      for pktoute'Address use pkt'Address ;
   begin
      pktoute := pktb ;
   end Set ;


   function CRC( pkt : QpacketType ) return Unsigned_32 is
      result : Unsigned_32 := 16#ffffffff# ;
      step1,step2,step3 : Unsigned_32 ;
      pkte : QpktElementsType ;
      for pkte'Address use pkt'Address ;
   begin
      for i in CRC_Start..CRC_End
      loop
         step1 := Shift_Right(result , 8 ) ;
         step2 := result and 16#0000_00ff# ;
         step3 := crc_table (1+Integer(Unsigned_32(pkte(Stream_Element_Offset(i))) xor step2 )) ;
         result := step1 xor
           step3  ;
      end loop ;
      return result ;
   end CRC ;

   procedure CRC( pkt : in out QpacketType ) is
   begin
      pkt.crc := CRC(pkt) ;
   end CRC ;

   function Check( pkt : QpacketType ) return boolean is
      computed : Unsigned_32 := CRC(pkt) ;
   begin
      if computed = pkt.crc
      then
         return true ;
      end if ;
      return False ;
   end Check ;

   function Image( pkt : QpacketType ) return String is
   begin
      return hex.Image( pkt'Address , pkt'Size/8 );
   end Image ;

   function Value( pktv : String ) return QpacketType is
      result : QpacketType ;
      resulte : QpktElementsType := (others => 16#88#) ;
      for resulte'Address use result'Address;
   begin
      return result ;
   end Value ;

   procedure Show( pkt : QpacketType ) is
   begin
      Show( pkt.mp );
      Put("CRC "); Put(hex.Image(pkt.crc)); New_Line;
   end Show ;

   procedure Show( pkte : QpktElementsType ) is
   begin
      null ;
   end Show ;

   procedure Show( mp : MeasurementPacket ) is
   begin
      Show( mp.measId ) ;
      Put("Value ");

      begin
         Put( mp.measValue ) ;
      exception
         when others => Put(" invalid ");
      end ;
      New_Line;

      Put("Precision "); Put( Integer(mp.precision) ); New_Line;
      Put("Units "); Put( Integer(mp.units) ); New_Line;
      Put("Alarm Code "); Put( Integer(mp.alarmCode) , base => 16 ); New_Line;
      Put("Alarm Limits: " );  Put("Lower "); Put(mp.lowerAlarmLimit); Put(" Upper "); Put(mp.upperAlarmLimit) ;New_Line;
   end Show ;

   procedure Show( measId : MeasurementId ) is
   begin
      null ;
   end Show ;



end q ;
