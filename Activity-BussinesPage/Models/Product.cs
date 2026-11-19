using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace Activity_BussinesPage.Models;

[Table("products")]
public class Product : BaseModel
{
    [PrimaryKey("id", false)]
    public long Id { get; set; }

    [Column("name")]
    public string Name { get; set; } = "";

    [Column("price")]
    public decimal Price { get; set; }

    [Column("deleted_at")]
    public DateTime? DeletedAt { get; set; }
}
