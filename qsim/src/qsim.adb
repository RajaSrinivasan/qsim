with Ada.Text_Io; use Ada.Text_Io;
with System.Storage_Elements; use System.Storage_Elements ;
with Interfaces; use Interfaces;

with Hex ;

with Q ;
procedure Qsim is


   p1 : constant String := "070102006ac251150000c07f007400000000000040400000000003b536e9bb0704" ;
   p1h : aliased Storage_Array := hex.Value(p1) ;

begin
   Put_Line(q.Version);
   declare
      p1hx : String := hex.Image(p1h'Address,p1h'Length);
   begin
      Put_Line(p1hx);
      Put_Line(p1);
      if p1hx /= p1
      then
         Put_Line("hex conversion failure");
      end if ;
   end ;
   declare
      pkt : aliased q.QpacketType ;
      pkte : Q.QpktElementsType ;
      for pkte'Address use p1h'Address ;
      pktcrc : Unsigned_32 ;
   begin
      Q.Set(pkt,pkte) ;
      pktcrc := Q.CRC(pkt);
      Put_Line(hex.Image(pktcrc));
   end ;
end Qsim;
