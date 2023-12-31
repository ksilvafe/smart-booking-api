// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract HotelBooking {
  struct RoomBooking {
    address guest;
    uint256 checkIn;
    uint256 checkOut;
  }

  mapping(uint256 => RoomBooking) public bookings;
  uint256 public bookingFree;
  address owner;

  event RoomBooked(uint256 roomId, address guest, uint256 checkIn, uint256 checkOut);
  event BookingCancelled(uint256 roomId, address guest);
  event PaymentReceveid(uint256 roomId, address guest);

  constructor(uint256 fee) {
    owner = msg.sender;
    bookingFree = fee;
  }

  function bookRoom(uint256 roomId, uint256 checkIn, uint256 checkOut) external payable {
    require(checkIn < checkOut, "Data de check-in e check-out invalidas");
    require(bookings[roomId].guest == address(0), "Quarto ja reservado");
    require(msg.value == bookingFree, "Pagamento insuficiente");

    bookings[roomId] = RoomBooking(msg.sender, checkIn, checkOut);
    emit RoomBooked(roomId, msg.sender, checkIn, checkOut);
  }

  function canceledBooking(uint256 roomId) external {
    require(bookings[roomId].guest == msg.sender, "Voce nao e o hospede deste quarto");

    delete bookings[roomId];
    emit BookingCancelled(roomId, msg.sender);
  }

  function withdramPayment(uint256 amount) external {
    require(msg.sender == owner, "Somente o dono do contrato pode sacar");
    require(amount <= address(this).balance, "Saldo do contrato insuficiente");
    payable(msg.sender).transfer(amount);
  }

}