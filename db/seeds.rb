# Environment-specific demo records; repeat runs do not duplicate or delete data.
catalog = [
  [ "Dune", "Frank Herbert", "12.50", "1965-08-01" ],
  [ "Pride and Prejudice", "Jane Austen", "8.25", "1813-01-28" ],
  [ "The Hobbit", "J. R. R. Tolkien", "10.99", "1937-09-21" ],
  [ "Frankenstein", "Mary Shelley", "7.50", "1818-01-01" ],
  [ "The Time Machine", "H. G. Wells", "6.75", "1895-05-07" ]
]
Book.transaction do
  catalog.each do |title, author, price, published_date|
    book = Book.find_or_initialize_by(title: "[#{Rails.env}] #{title}")
    book.update!(author: author, price: price, published_date: published_date)
  end
end
puts "Seeded #{catalog.length} demo books in #{Rails.env} (#{ActiveRecord::Base.connection_db_config.database})."
