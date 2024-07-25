package consubanco.pet;

import com.intuit.karate.junit5.Karate;

public class RunnerPet {
    @Karate.Test
    Karate testGet() { return Karate.run("pet-post").relativeTo(getClass());
    }
}
