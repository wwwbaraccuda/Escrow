pragma solidity >0.7.0 <=0.9.0;

contract Escrow {

    address arbiter;
    address pembeli;
    address penjual;
    uint uangPembeli;
    bool isApproved;
    bool isDispute;

    constructor(address _arbiter, address _pembeli, address _penjual) {
        arbiter = _arbiter;
        pembeli = _pembeli;
        penjual = payable (_penjual);
    } 

    function inputUang() public payable {
        require(msg.sender == pembeli, "Harus pembeli");
        pembeli = payable(msg.sender);
    }

    function Approve() public {
        require(msg.sender == pembeli, "Pembeli yang berwenang");
        require(!isDispute, "Penjual dispute");
        isApproved = true;

    }

    function Release() public payable{
        require(isApproved == true, "Pembeli tidak approve");
        require(msg.sender == penjual, "Penjual yang berwenang");
        require(!isDispute, "Pembeli dispute");
        payable (penjual).transfer(address(this).balance);
    }

    function Dispute() public {
        require(msg.sender == penjual || msg.sender == pembeli, "Hanya pembeli dan penjual yang bisa Dispute");
        isDispute = true;
    }

    function Resolve() public {
        require(isDispute, "Pembeli dan Penjual tidak dispute");
        require(msg.sender == arbiter, "Hanya arbiter yang berwenang");
        payable (penjual).transfer(address(this).balance);
    }

    function Refund() public {
        require(isDispute, "Pembeli dan Penjual tidak dispute");
        require(msg.sender == arbiter, "Hanya arbiter yang berwenang");
        payable (pembeli).transfer(address(this).balance);
    }
}
