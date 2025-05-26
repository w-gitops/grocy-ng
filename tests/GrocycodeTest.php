<?php

use Grocy\Helpers\Grocycode;
use PHPUnit\Framework\TestCase;

class GrocycodeTest extends TestCase
{
    public function testLocationGrocycodeEncoding()
    {
        // Test encoding a location ID (e.g., 5) into a Grocycode string.
        // Expected: "grcy:l:5"
        // $grocycode = new Grocycode(Grocycode::LOCATION, 5);
        // $this->assertEquals("grcy:l:5", (string)$grocycode);
    }

    public function testLocationGrocycodeDecoding()
    {
        // Test decoding a location Grocycode string "grcy:l:12" back to its components.
        // Expected type: Grocycode::LOCATION
        // Expected id: 12
        // $grocycode = new Grocycode("grcy:l:12");
        // $this->assertEquals(Grocycode::LOCATION, $grocycode->GetType());
        // $this->assertEquals(12, $grocycode->GetId());
    }

    public function testLocationGrocycodeWithExtraDataEncoding()
    {
        // Test encoding a location ID (e.g., 7) with extra data into a Grocycode string.
        // Expected: "grcy:l:7:extradata"
        // $grocycode = new Grocycode(Grocycode::LOCATION, 7, ["extradata"]);
        // $this->assertEquals("grcy:l:7:extradata", (string)$grocycode);
    }

    public function testLocationGrocycodeWithExtraDataDecoding()
    {
        // Test decoding a location Grocycode string "grcy:l:15:foo:bar" back to its components.
        // Expected type: Grocycode::LOCATION
        // Expected id: 15
        // Expected extra data: ["foo", "bar"]
        // $grocycode = new Grocycode("grcy:l:15:foo:bar");
        // $this->assertEquals(Grocycode::LOCATION, $grocycode->GetType());
        // $this->assertEquals(15, $grocycode->GetId());
        // $this->assertEquals(["foo", "bar"], $grocycode->GetExtraData());
    }
}
