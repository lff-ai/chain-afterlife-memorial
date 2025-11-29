import hre from "hardhat";
import { ethers } from "ethers";

async function main() {
  const privateKey = process.env.MONAD_TESTNET_PRIVATE_KEY;
  if (!privateKey) {
    throw new Error("Missing MONAD_TESTNET_PRIVATE_KEY");
  }

  const artifact = await hre.artifacts.readArtifact("TombGarden");
  const rpcUrl = process.env.MONAD_TESTNET_RPC || "https://testnet-rpc.monad.xyz";
  const provider = new ethers.JsonRpcProvider(rpcUrl, {
    chainId: 10143,
    name: "monadTestnet",
  });
  const signer = new ethers.Wallet(privateKey, provider);
  const factory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, signer);
  const tombGarden = await factory.deploy();

  await tombGarden.waitForDeployment();
  console.log("TombGarden deployed to:", await tombGarden.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
