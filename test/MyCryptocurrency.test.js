const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DEADMAN Token", function () {
  let token;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    // Get test accounts
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy token contract
    const MyCryptocurrency = await ethers.getContractFactory("MyCryptocurrency");
    token = await MyCryptocurrency.deploy("DEADMAN", "DEAD");
    await token.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await token.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply to the owner", async function () {
      const ownerBalance = await token.balanceOf(owner.address);
      const totalSupply = await token.totalSupply();
      expect(ownerBalance).to.equal(totalSupply);
    });

    it("Should have correct name and symbol", async function () {
      expect(await token.name()).to.equal("DEADMAN");
      expect(await token.symbol()).to.equal("DEAD");
    });

    it("Should have 18 decimals", async function () {
      expect(await token.decimals()).to.equal(18);
    });
  });

  describe("Minting", function () {
    it("Should allow owner to mint tokens", async function () {
      const mintAmount = ethers.parseEther("1000");
      
      await token.mint(addr1.address, mintAmount);
      
      const balance = await token.balanceOf(addr1.address);
      expect(balance).to.equal(mintAmount);
    });

    it("Should not allow non-owner to mint tokens", async function () {
      const mintAmount = ethers.parseEther("1000");
      
      await expect(
        token.connect(addr1).mint(addr2.address, mintAmount)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should not allow minting beyond max supply", async function () {
      const maxSupply = await token.MAX_SUPPLY();
      const currentSupply = await token.totalSupply();
      const excessiveAmount = maxSupply - currentSupply + 1n;
      
      await expect(
        token.mint(addr1.address, excessiveAmount)
      ).to.be.revertedWith("DEADMAN: Max supply exceeded");
    });
  });

  describe("Burning", function () {
    beforeEach(async function () {
      // Give addr1 some tokens to burn
      const amount = ethers.parseEther("1000");
      await token.transfer(addr1.address, amount);
    });

    it("Should allow token holders to burn their tokens", async function () {
      const burnAmount = ethers.parseEther("100");
      const initialBalance = await token.balanceOf(addr1.address);
      
      await token.connect(addr1).burn(burnAmount);
      
      const finalBalance = await token.balanceOf(addr1.address);
      expect(finalBalance).to.equal(initialBalance - burnAmount);
    });

    it("Should reduce total supply when burning", async function () {
      const burnAmount = ethers.parseEther("100");
      const initialSupply = await token.totalSupply();
      
      await token.connect(addr1).burn(burnAmount);
      
      const finalSupply = await token.totalSupply();
      expect(finalSupply).to.equal(initialSupply - burnAmount);
    });
  });

  describe("Pause Functionality", function () {
    it("Should allow owner to pause transfers", async function () {
      await token.pause();
      expect(await token.paused()).to.be.true;
    });

    it("Should prevent transfers when paused", async function () {
      const amount = ethers.parseEther("100");
      
      await token.pause();
      
      await expect(
        token.transfer(addr1.address, amount)
      ).to.be.revertedWith("DEADMAN: Token transfer while paused");
    });

    it("Should allow transfers after unpausing", async function () {
      const amount = ethers.parseEther("100");
      
      await token.pause();
      await token.unpause();
      
      await expect(token.transfer(addr1.address, amount)).to.not.be.reverted;
    });
  });

  describe("Transfers", function () {
    it("Should transfer tokens between accounts", async function () {
      const amount = ethers.parseEther("100");
      
      await token.transfer(addr1.address, amount);
      
      const balance1 = await token.balanceOf(addr1.address);
      expect(balance1).to.equal(amount);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const amount = ethers.parseEther("1000");
      
      await expect(
        token.connect(addr1).transfer(addr2.address, amount)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
    });
  });

  describe("Allowances", function () {
    it("Should approve and transfer tokens via allowance", async function () {
      const amount = ethers.parseEther("100");
      
      await token.approve(addr1.address, amount);
      await token.connect(addr1).transferFrom(owner.address, addr2.address, amount);
      
      const balance2 = await token.balanceOf(addr2.address);
      expect(balance2).to.equal(amount);
    });
  });
});