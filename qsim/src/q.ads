with Ada.Streams ; use Ada.Streams ;
with Interfaces ; use Interfaces ;

package q is

   -- Baud Rate 115200
   -- Data Bits 8
   -- Stop Bit 1
   -- Parity None
   -- Flow Control None

   PACKET_SIZE : constant := 33 ;
   MEASUREMENT_PKT_SIZE : constant := 23 ;

   BEL : constant := 16#07# ;
   SOH : constant := 16#01# ;
   STX : constant := 16#02# ;
   ETX : constant := 16#03# ;
   EOT : constant := 16#04# ;

   type Start_Packet is
      record
         bel : Unsigned_8 := 16#07# ;
         soh : Unsigned_8 := 15#01# ;
      end record ;
   for Start_Packet'Size use 2*8 ;

   type DeviceType is mod 2**8 ;
   QWS15 : constant DeviceType := 1 ;
   QWS12 : constant DeviceType := 2 ;
   QWS12EliteG2 : constant DeviceType := 7 ;

   type DeviceNumber is mod 2**5 ;
   type Socket is mod 2**6 ;

   type SensorPart is mod 2**4 ;

   PreSATSO2 : constant SensorPart := 2;
   PostSATSO2 : constant SensorPart := 1;

   type MeasurementType is mod 2**9 ;

   QMNone : constant MeasurementType := 100 ;
   QMSO2 : constant MeasurementType := 101 ;
   QMHb : constant MeasurementType := 102 ;
   QMHct : constant MeasurementType := 103 ;
   QMCIW : constant MeasurementType := 125 ;

   type MeasurementId is
      record
         dt : DeviceType ;
         dn : DeviceNumber ;
         s : Socket ;
         sp : SensorPart ;
         mt : MeasurementType ;
      end record ;
   for MeasurementId use
      record
         dt at 0 range 0..7 ;
         dn at 0 range 8..12 ;
         s at 0 range 13..18 ;
         sp at 0 range 19..22 ;
         mt at 0 range 23..31 ;
      end record ;
   for MeasurementId'Size use 32 ;

   type MeasurementPacket is
      record
         stx : Unsigned_8 := 16#02# ;
         PacketType : Unsigned_8 := 16#00# ;
         measId : MeasurementId ;
         measValue : Float ;
         precision : Unsigned_8 ;
         units : Unsigned_8 ;
         alarmCode : Unsigned_32 ;
         upperAlarmLimit : float ;
         lowerAlarmLimit : float ;
         eom : Unsigned_8 := 16#03# ;
      end record
     with Convention => C ;
   pragma pack(MeasurementPacket);

   QNTM_PKT_TYPE_MEASUAREMENT : constant := 0 ;

   type QpacketType is
      record
         sop : Start_Packet ;
         mp : MeasurementPacket ;
         crc : Unsigned_32 := 0 ;
         bel : Unsigned_8 := 16#07# ;
         eot : Unsigned_8 := 16#04# ;
      end record
   with Convention => C ;
   pragma pack(QpacketType);
   for QpacketType'Size use PACKET_SIZE*8 ;

   type QpktElementsType is new Stream_Element_Array(1..PACKET_SIZE) ;

   CRC_basis : constant := 16#EDB88320# ;

   function Version return String ;
   CRC_Start : constant := 3 ;
   CRC_End : constant := 27 ;
   procedure Set( pkt : out QpacketType ; pktb : QpktElementsType );
   function CRC( pkt : QpacketType ) return Unsigned_32 ;
   procedure CRC( pkt : in out QpacketType ) ;
   function Check( pkt : QpacketType ) return boolean ;
   function Image( pkt : QpacketType ) return String ;
      function Value( pktv : String ) return QpacketType ;
   procedure Show( pkt : QpacketType ) ;
   procedure Show( pkte : QpktElementsType ) ;
   procedure Show( mp : MeasurementPacket );
   procedure Show( measId : MeasurementId );
end q ;
