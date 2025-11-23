import dotenv from "dotenv";

dotenv.config({ path: `.env.${process.env.NODE_ENV || "local"}` });

export const config = {
  environment: process.env.NODE_ENV || "local",

  crossmint: {
    apiKey: process.env.CROSSMINT_API_KEY!,
    projectId: process.env.CROSSMINT_PROJECT_ID!,
  },

  contracts: {
    rewardDistributor: process.env.REWARD_DISTRIBUTOR!,
    torahAgentNFT: process.env.TORAH_AGENT_NFT!,
    usdc: process.env.USDC_ADDRESS!,
  },

  port: process.env.BACKEND_PORT || 3001,
};
