public abstract class Continue<R> {
    public continueWithDispatch()
}
private static final class Continue<R> extends Continue<R> {
    Continue (Dispatch<R> dispatch, Continuation continuation) {..}
}
private static final class Final<R> extends Continue<R> {
    Final ()
}
public final class Continue {
    public Continue(Dispatch dispatch, Continuation continuation);
}
public interface Continuation<R> {
    ContReturn<R> continue(Object... args);
}

public class MyOp {
    @DataflowFunction(input=NON_STRICT, output=NON_STRICT)
    public ContReturn<Object[]> myFunction(@Strict Object arg0, Optional<Object> arg1, Optional<Object> arg2) {
        if (arg1.isPresent() && arg2.isPresent())
            return Continue.final(new Object[] {a, b, c});
        else if (arg2.isPresent())
            return Continue.continueWithDispatch(Dispatch.partial(new Tuple<>(0, a), new Tuple<>(2, c)), (arg1) -> ...);
        else
            return Continue.continue((arg1, arg2) -> ...);
        }
    }
}
