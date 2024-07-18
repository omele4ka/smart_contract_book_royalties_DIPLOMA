const BookRoyalties = artifacts.require("BookRoyalties");

module.exports = function(deployer) {
  deployer.deploy(BookRoyalties);
};