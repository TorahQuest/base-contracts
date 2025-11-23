import express from "express";
import { CrossmintWalletSDK } from "@crossmint/wallet-sdk";
import { config } from "./config";

const app = express();
app.use(express.json());

const crossmint = new CrossmintWalletSDK({
  apiKey: config.crossmint.apiKey,
  projectId: config.crossmint.projectId,
});

app.post("/create-wallet", async (req, res) => {
  const { email } = req.body;

  try {
    const wallet = await crossmint.wallets.create({
      authentication: { type: "email", email },
      chain: config.environment === "production" ? "base" : "base-sepolia",
    });

    const agentSigner = await crossmint.delegatedSigners.create(wallet.address, {
      policy: {
        allowedContracts: [config.contracts.rewardDistributor],
        maxAmountPerDay: "100 USDC",
      },
    });

    res.json({
      walletAddress: wallet.address,
      agentJwt: agentSigner.jwt,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.listen(config.port, () => {
  console.log(`Torah Quest backend [${config.environment}] running on port ${config.port}`);
});
