import Foundation
import Operation_iOS
import SubstrateSdk

final class ImmortalEraOperationFactory: ExtrinsicEraOperationFactoryProtocol {
    func createOperation(
        from _: JSONRPCEngine,
        runtimeService _: RuntimeCodingServiceProtocol
    ) -> CompoundOperationWrapper<ExtrinsicEraParameters> {
        let parameters = ExtrinsicEraParameters(blockNumber: 0, extrinsicEra: .immortal)
        return CompoundOperationWrapper.createWithResult(parameters)
    }
}
