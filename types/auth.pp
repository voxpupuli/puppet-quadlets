# @summary custom datatype to specify username and password
type Quadlets::Auth = Struct[{
  'username' => String[1],
  'password' => Variant[String[1],Sensitive[String[1]]],
}]
