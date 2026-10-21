# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
[
  ["Batman", 0.10821806346623271, 0.792354474370113],
  ["Spider-Man", 0.6436126932465419, 0.9548218940052129],
  ["Johnny Bravo", 0.44182262001627337, 0.8637209879607795],
  ["Ryuk", 0.1742588575560376, 0.6541685046316719],
  ["Mario", 0.06724511930585683, 0.24779444199382444],
  ["Tom", 0.8626174981923355, 0.9675782973092192],
  ["Link", 0.2292118582791034, 0.9719894133215704],
  ["Aang", 0.064352856109906, 0.8445081605646229],
  ["Lupin III", 0.5422993492407809, 0.7516541685046316],
  ["Casper", 0.1475054229934924, 0.3239964711071901],
  ["Patrick", 0.6623270951993491, 0.8562740474121882],
  ["Ash", 0.028199566160520606, 0.9186149095721218],
  ["Astro Boy", 0.9487388120423108, 0.8570187414670473],
  ["Waldo", 0.818, 0.8932957058958126],
  ["Kenny", 0.593, 0.8443291892304172],
  ["Slimer", 0.05, 0.21699336435054534],
  ["Krang", 0.475, 0.592632140950347],
  ["Darkwing Duck", 0.7805, 0.8244985126992601],
  ["Predator", 0.9425, 0.7867439554572496],
  ["Brian Griffin", 0.141, 0.8182442224086645],
  ["Samus Aran", 0.6325, 0.9686522767142094],
  ["Jake the Dog", 0.69, 0.9254061475097246],
  ["Wolverine", 0.245, 0.9640759667454809],
  ["Vash the Stampede", 0.0275, 0.9644573259095416],
  ["Leeloo", 0.85, 0.540157119975593],
  ["Cortana", 0.92, 0.8521089161772557],
  ["Battle Droid", 0.735, 0.19792540614750972],
  ["Stewie Griffin", 0.942, 0.8523377316756922],
  ["Finn", 0.6695, 0.9231942643581725],
  ["Minion", 0.7825, 0.4095797422012051],
  ["The Mandalorian", 0.4, 0.10830600259324231],
  ["Jabba the Hutt", 0.625, 0.8023796811837388],
  ["Zoidberg", 0.84, 0.9072534513004348]
].each do |name, x_coordinate, y_coordinate|
  Character.find_or_create_by!(name:) do |character|
    character.assign_attributes(x_coordinate:, y_coordinate:)
  end
end
