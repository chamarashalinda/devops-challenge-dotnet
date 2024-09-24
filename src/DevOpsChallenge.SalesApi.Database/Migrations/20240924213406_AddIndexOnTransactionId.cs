using Microsoft.EntityFrameworkCore.Migrations;

namespace DevOpsChallenge.SalesApi.Database.Migrations
{
    public partial class AddIndexOnTransactionId : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Transaction_TransactionId",
                table: "Sale",
                column: "TransactionId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Transactions_TransactionId",
                table: "Sale");
        }
    }
}
