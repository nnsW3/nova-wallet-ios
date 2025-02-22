import Foundation
import Operation_iOS
import BigInt

final class SubqueryTotalRewardSource {
    typealias Model = TotalRewardItem

    let address: AccountAddress
    let startTimestamp: Int64?
    let endTimestamp: Int64?
    let assetPrecision: Int16
    let operationFactory: SubqueryRewardOperationFactoryProtocol
    let stakingType: SubqueryStakingType

    init(
        address: AccountAddress,
        startTimestamp: Int64?,
        endTimestamp: Int64?,
        assetPrecision: Int16,
        operationFactory: SubqueryRewardOperationFactoryProtocol,
        stakingType: SubqueryStakingType
    ) {
        self.address = address
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.assetPrecision = assetPrecision
        self.operationFactory = operationFactory
        self.stakingType = stakingType
    }

    private func createMapOperation(
        dependingOn fetchOperation: BaseOperation<BigUInt>,
        address: AccountAddress,
        precision: Int16
    ) -> BaseOperation<Model?> {
        ClosureOperation<Model?> {
            let rewardValue = try fetchOperation.extractNoCancellableResultData()
            let newRewardDecimal = Decimal.fromSubstrateAmount(rewardValue, precision: precision) ?? 0
            return TotalRewardItem(address: address, amount: AmountDecimal(value: newRewardDecimal))
        }
    }
}

extension SubqueryTotalRewardSource: SingleValueProviderSourceProtocol {
    func fetchOperation() -> CompoundOperationWrapper<Model?> {
        let rewardOperation = operationFactory.createTotalRewardOperation(
            for: address,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            stakingType: stakingType
        )

        let mapOperation = createMapOperation(
            dependingOn: rewardOperation,
            address: address,
            precision: assetPrecision
        )

        mapOperation.addDependency(rewardOperation)

        return CompoundOperationWrapper(targetOperation: mapOperation, dependencies: [rewardOperation])
    }
}
