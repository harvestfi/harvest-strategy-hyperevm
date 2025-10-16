const ULRegistryContract = artifacts.require("UniversalLiquidatorRegistry");
const ULContract = artifacts.require("UniversalLiquidator");

async function main() {
  console.log("Deploying UL Core contracts");

  const ULR = await ULRegistryContract.new()

  console.log("Deployment complete. UL Registry deployed at:", ULR.address);

  try {
    await hre.run("verify:verify", {address: ULR.address}); 
  } catch (e) {
    console.log("Verification error:", e);
  }

  const UL = await ULContract.new()

  console.log("Deployment complete. UL deployed at:", UL.address);

  try {
    await hre.run("verify:verify", {address: UL.address}); 
  } catch (e) {
    console.log("Verification error:", e);
  }
  await UL.setPathRegistry(ULR.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
