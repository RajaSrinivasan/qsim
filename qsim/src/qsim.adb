with Ada.Text_Io; use Ada.Text_Io;
with System.Storage_Elements; use System.Storage_Elements ;
with Interfaces; use Interfaces;

with GNAT.Source_Info ;

with Hex ;

with Q ;
procedure Qsim is


   p1 : constant String := "070102006ac251150000c07f007400000000000040400000000003b536e9bb0704" ;
   p2 : constant String := "07010200690252150000c07f00410000000000004844000048c3033e91e42a0704" ;
   p3 : constant String := "0701020090000008f542bfc100410000000000007a4400007ac40347fcee840704" ;
   p4 : constant String := "070102008f000008226e6c3d02230000000000002042000020c20351a646180704" ;


   p1h : aliased Storage_Array := hex.Value(p1) ;

   procedure T1( p : String ) is
      myname : String := gnat.Source_Info.Enclosing_Entity ;
      ph : aliased Storage_Array := hex.Value(p) ;
      pkt : aliased q.QpacketType ;
      pkte : Q.QpktElementsType ;
      for pkte'Address use ph'Address ;
      pktcrc : Unsigned_32 ;
   begin
      Put_Line(myname);
      Q.Set(pkt,pkte) ;
      pktcrc := Q.CRC(pkt);
      Put_Line(p);
      Put_Line(hex.Image(pktcrc));
      q.Show(pkt);
   end T1 ;

begin
   Put_Line(q.Version);
   T1(p1);
   T1(p2);
   T1(p3);
   T1(p4);
end Qsim;
