import { ethers } from "hardhat";

async function main() {

  const Auction = await ethers.getContractFactory(
    "auction"
  );
  const auc= await Auction.deploy("0xdD2FD4581271e230360230F9337D5c0430Bf44C0", 2);
  await auc.deployed();

  console.log("auction deployed to: ", auc.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });