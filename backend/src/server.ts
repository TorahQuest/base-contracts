import express from "express";
import { CrossmintWalletSDK } from "@crossmint/wallet-sdk";

const app = express();
app.use(express.json());

const CROSSMINT_API_KEY = "sk_staging_AFXHqbZhNd6xCxLpYNW8JD5jMviSCFPXaHfAY7pSwNt8qvQC4DWL1icFR4rVZqu9UrL5HtLc5FRiST6XE2ACMkpWSqxi732gBapvW3y51qoWhQ2x8gu214KqX7P3RXLRrMkaNjj1ySdKWTrDSnsGVi5P1bY6qGzypMBcEdY4sahBB9zfzzdYuQ9JvvvimzS38VynruwebL9FJ71atByddHFV";
const PROJECT_ID = "f6c21632-4e84-4318-bb8b-e7f45371a269";

app.post("/create-wallet", async (req, res) => {
  const { email } = req.body;

  const crossmint = new CrossmintWalletSDK({
    apiKey: CROSSMINT_API_KEY,
    projectId: PROJECT_ID,
  });

  });

  const wallet = await crossmint.wallets.create({
    authentication: { type: "email", email },
    chain: "base-sepolia",
  });

  // Create delegated signer for Grok-4 agent
  const agentSigner = await crossmint.delegatedSigners.create(wallet.address, {
    policy: {
      allowedContracts: [process.env.REWARD_DISTRIBUTOR],
      maxAmountPerDay: "100 USDC",
    },
  });

  res.json({ walletAddress: wallet.address, agentJwt: agentSigner.jwt });
});

app.listen(3001, () => console.log("Backend live on 3001"));
