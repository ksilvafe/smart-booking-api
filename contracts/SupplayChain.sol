// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

contract SupplayChain is Ownable {
  constructor() Ownable(msg.sender) {}

  // Enum com todos os status de um pedido.
  enum Status {
    Ordered,
    Shipped,
    Delivered,
    Cancelled
  }

  struct Item {
    uint id; //identificador de um item.
    string name; //nome do item.
    Status status; // status do item.
    address orderedBy; // endereço de quem realizou o pedido.
    address approvedBy; // endereço de quem aprovou o pedido.
    address deliveredTo; //endereço para o qual o item foi entregue.
  }

  mapping(uint => Item) private items;
  uint private itemCount;

  function orderItem(string memory _name) public {
    // funcao para realizar pedido de um novo item
    Item memory newItem = Item({
      id: itemCount,
      name: _name,
      status: Status.Ordered,
      orderedBy: msg.sender,
      approvedBy: address(0),
      deliveredTo: address(0)
    });
    items[itemCount] = newItem;
    // Armazena o novo item no mapeamento
    itemCount++;
    // Incrementa o contador de itens.
  }

  function cancelledItem(uint _id) public {
    require(
      items[_id].orderedBy == msg.sender, "Somente a pessoa que fez o pedido pode cancelar"
    );

    require(
      items[_id].status == Status.Ordered,
      "O item so pode ser cancelado se estiver no estado Ordered"
    );

    item[_id].status = Status.Cancelled;
  }

  function approvedItem(uint _id) public onlyOwner {
    require(
      items[_id].status = Status.Ordered,
      "O item deve estar no estado Ordered para ser aprovado"
    );

    items[_id].status = Status.Shipped;
    items[_id].approvedBy = msg.send;
  }

  function shipItem(uint _id) public onlyOwner {
    require(
      items[_id].status = Status.Shipped, 
      "O item deve estar no estado de Shipped para ser enviado"
    );

    items[_id].status = Status.Delivered;
    items[_id].deliveredTo = item[_id].orderedBy;
  }

  function getItemStatus(uint _id) public view returns (Status) {
    return items[_id].status;
  }

  function getItem(uint _id) public view returns (Item memory) {
    return items[_id];
  }

  function getItemCount() public view returns (uint) {
    return itemCount;
  }
}